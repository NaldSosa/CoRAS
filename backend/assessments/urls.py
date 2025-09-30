from django.urls import path
from .views import create_assessment

urlpatterns = [
    path("create/", create_assessment, name="create_assessment"),
]

