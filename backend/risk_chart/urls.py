from django.urls import path
from .views import get_risk_assessment

urlpatterns = [
    path("get-risk/", get_risk_assessment, name="get-risk"),
]