from django.contrib.auth.models import Group
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
    groups = serializers.SlugRelatedField(
        many=True,
        slug_field="name",
        queryset=Group.objects.all()  # allow writing group names
    )
    barangay = BarangaySerializer(read_only=True)
    barangay_id = serializers.PrimaryKeyRelatedField(
        queryset=Barangay.objects.all(),
        source="barangay",
        write_only=True,
        required=False
    )
    rhu = RuralHealthUnitSerializer(read_only=True)
    rhu_id = serializers.PrimaryKeyRelatedField(
        queryset=RuralHealthUnit.objects.all(),
        source="rhu",
        write_only=True,
        required=False
    )

    class Meta:
        model = CustomUser
        fields = [
            "id", "username", "email",
            "first_name", "middle_name", "last_name", "suffix",
            "groups", "barangay", "rhu", "barangay_id", "rhu_id",
            "phone_number", "age", "sex", "password",
        ]

    def create(self, validated_data):
        groups_data = validated_data.pop("groups", [])
        password = validated_data.pop("password", None)

        # ✅ Remove keys that don't exist on the CustomUser model
        validated_data.pop("barangay", None)
        validated_data.pop("rhu", None)

        # ✅ Create user
        user = CustomUser(**validated_data)
        if password:
            user.set_password(password)
        user.save()

        # ✅ Assign groups
        for group in groups_data:
            user.groups.add(group)

        return user

    def update(self, instance, validated_data):
        password = validated_data.pop("password", None)

        # ✅ Remove fields not in CustomUser
        validated_data.pop("barangay", None)
        validated_data.pop("rhu", None)

        # ✅ Handle groups separately
        groups_data = validated_data.pop("groups", None)

        # ✅ Update normal fields
        for attr, value in validated_data.items():
            setattr(instance, attr, value)

        # ✅ Update password if provided
        if password:
            instance.set_password(password)

        instance.save()

        # ✅ Safely update groups
        if groups_data is not None:
            instance.groups.set(groups_data)

        return instance

