from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import UserViewSet, BarangayViewSet, RHUViewSet

router = DefaultRouter()
router.register(r'users', UserViewSet)
router.register(r'barangays', BarangayViewSet)
router.register(r'rhus', RHUViewSet)

urlpatterns = [
    path("", include(router.urls)),
]
