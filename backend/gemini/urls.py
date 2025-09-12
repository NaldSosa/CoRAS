from django.urls import path
from . import views

urlpatterns = [
    path("risk-assessment/", views.risk_assessment_view, name="risk_assessment"),
]
