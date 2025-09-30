from rest_framework import generics
from db_models.models import PatientInformation
from .serializers import PatientListSerializer, PatientDetailSerializer

class PatientListView(generics.ListAPIView):
    queryset = PatientInformation.objects.all()
    serializer_class = PatientListSerializer

class PatientDetailView(generics.RetrieveAPIView):
    queryset = PatientInformation.objects.all()
    serializer_class = PatientDetailSerializer
