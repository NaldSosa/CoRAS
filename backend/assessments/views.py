from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
from .serializers import AssessmentSerializer

@api_view(["POST"])
def create_assessment(request):
    serializer = AssessmentSerializer(data=request.data, context={"request": request})
    if serializer.is_valid():
        result = serializer.save()
        return Response(result, status=status.HTTP_201_CREATED)
    else:
        print("Validation errors:", serializer.errors)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

