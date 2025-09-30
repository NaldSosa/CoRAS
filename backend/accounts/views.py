from django.http import JsonResponse
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from django.contrib.auth import get_user_model, authenticate, login
from rest_framework_simplejwt.tokens import RefreshToken
from .serializers import UserSerializer
from rest_framework.permissions import AllowAny

User = get_user_model()

class BhwLoginView(APIView):
    permission_classes = [AllowAny]

    def post(self, request):
        username_or_email = request.data.get("username")
        password = request.data.get("password")

        user = (
            User.objects.filter(username=username_or_email).first()
            or User.objects.filter(email=username_or_email).first()
        )

        print("DEBUG USER FOUND:", user)

        if user is None or not user.check_password(password):
            return Response({"detail": "Invalid credentials"}, status=status.HTTP_401_UNAUTHORIZED)

        print("DEBUG:", user.username, list(user.groups.values_list("id", "name")))

        if not user.groups.filter(name="Barangay Health Worker").exists():
            return Response({"detail": "Access denied"}, status=status.HTTP_403_FORBIDDEN)


        refresh = RefreshToken.for_user(user)

        return Response({
            "access_token": str(refresh.access_token),
            "refresh_token": str(refresh),
            "user": UserSerializer(user).data,
        })

class WebLoginView(APIView):
    permission_classes = [AllowAny]
    def post(self, request):
        username = request.data.get("username")
        password = request.data.get("password")

        user = authenticate(request, username=username, password=password)

        if user is None:
            return Response({"detail": "Invalid credentials"}, status=status.HTTP_401_UNAUTHORIZED)

        if not (user.is_superuser or user.groups.filter(name="Admin").exists() or user.groups.filter(name="Municipal Health Worker").exists()):
            return Response({"detail": "Access denied"}, status=status.HTTP_403_FORBIDDEN)

        login(request, user) 

        return Response({
            "message": "Login successful",
            "user": UserSerializer(user).data,
        })

def health_check(request):
    return JsonResponse({"status": "ok"})

