from django.contrib import admin
from django.urls import path, include
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView

urlpatterns = [
    path('admin/', admin.site.urls),
    path("", include("gemini.urls")),
    path("accounts/", include("accounts.urls")),
    path("risk-chart/", include("risk_chart.urls")),
    path("api/", include("user_management.urls")),
    path("api/token/", TokenObtainPairView.as_view(), name="token_obtain_pair"),
    path("api/token/refresh/", TokenRefreshView.as_view(), name="token_refresh"),
    path("assessments/", include("assessments.urls")),
    path("view/", include("patients.urls")),
]
