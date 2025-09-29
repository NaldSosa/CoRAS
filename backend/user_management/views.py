from rest_framework import viewsets, permissions
from rest_framework.decorators import action
from rest_framework.response import Response
from db_models.models import CustomUser, Barangay, RuralHealthUnit
from .serializers import CustomUserSerializer, BarangaySerializer, RuralHealthUnitSerializer

class UserViewSet(viewsets.ModelViewSet):
    queryset = CustomUser.objects.all()
    serializer_class = CustomUserSerializer
    permission_classes = [permissions.IsAuthenticated]

    @action(detail=False, methods=["get"])
    def location_options(self, request):
        role = request.query_params.get("role")
        if role == "Barangay Health Worker":
            data = BarangaySerializer(Barangay.objects.all(), many=True).data
        elif role in ["Admin", "Municipal Health Worker"]:
            data = RuralHealthUnitSerializer(RuralHealthUnit.objects.all(), many=True).data
        else:
            data = []
        return Response(data)

class BarangayViewSet(viewsets.ModelViewSet):
    queryset = Barangay.objects.all()
    serializer_class = BarangaySerializer
    permission_classes = [permissions.IsAuthenticated]

class RHUViewSet(viewsets.ModelViewSet):
    queryset = RuralHealthUnit.objects.all()
    serializer_class = RuralHealthUnitSerializer
    permission_classes = [permissions.IsAuthenticated]
