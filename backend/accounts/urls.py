from django.urls import path
from rest_framework_simplejwt.views import TokenRefreshView
from .views import BhwLoginView, WebLoginView, health_check

urlpatterns = [
    path("mobile-login/", BhwLoginView.as_view(), name="bhw-login"),
    path("web-login/", WebLoginView.as_view(), name="web-login"),
    path("refresh/", TokenRefreshView.as_view(), name="token-refresh"),
    path("health-check/", health_check, name="health-check"),
]
