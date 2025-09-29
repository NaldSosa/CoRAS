from rest_framework import serializers
from db_models.models import CustomUser, Barangay, RuralHealthUnit

class BarangaySerializer(serializers.ModelSerializer):
    class Meta:
        model = Barangay
        fields = ["id", "barangay_name"]

class RuralHealthUnitSerializer(serializers.ModelSerializer):
    class Meta:
        model = RuralHealthUnit
        fields = ["id", "rhu_name"]

class CustomUserSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True, required=True)
    barangay = BarangaySerializer(read_only=True)
    rhu = RuralHealthUnitSerializer(read_only=True)
    barangay_id = serializers.PrimaryKeyRelatedField(
        queryset=Barangay.objects.all(), source="barangay", write_only=True, required=False
    )
    rhu_id = serializers.PrimaryKeyRelatedField(
        queryset=RuralHealthUnit.objects.all(), source="rhu", write_only=True, required=False
    )

    class Meta:
        model = CustomUser
        fields = [
            "id", "username", "email", "first_name", "last_name",
            "role", "barangay", "rhu", "barangay_id", "rhu_id",
            "phone_number", "age", "sex", "password"
        ]

    def create(self, validated_data):
        password = validated_data.pop("password")
        user = CustomUser(**validated_data)
        user.set_password(password)
        user.save()
        return user

    def update(self, instance, validated_data):
        password = validated_data.pop("password", None)
        for attr, value in validated_data.items():
            setattr(instance, attr, value)
        if password:
            instance.set_password(password)
        instance.save()
        return instance
