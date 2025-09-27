from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path('admin/', admin.site.urls),
    path("", include("gemini.urls")),
    path("api/", include("risk_chart.urls")),
]
