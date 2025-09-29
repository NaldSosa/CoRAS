from django.urls import path
from .views import AssessmentCreateView, AssessmentBulkSyncView

urlpatterns = [
    path("assessments/", AssessmentCreateView.as_view(), name="create-assessment"),
    path("assessments/bulk-sync/", AssessmentBulkSyncView.as_view(), name="bulk-sync"),
]
