from django.contrib import admin
from .models import (
    CustomUser,
    Barangay,
    RuralHealthUnit,
    ActivityLog,
    Quota,
    PatientInformation,
    Assessment,
    PatientIntakeRecord,
    PatientScreening,
    RiskLevel,
    RiskChart,
    Result,
    Appointment,
    Configuration,
)

admin.site.register(CustomUser)
admin.site.register(Barangay)
admin.site.register(RuralHealthUnit)
admin.site.register(ActivityLog)
admin.site.register(Quota)
admin.site.register(PatientInformation)
admin.site.register(Assessment)
admin.site.register(PatientIntakeRecord)
admin.site.register(PatientScreening)
admin.site.register(RiskLevel)
admin.site.register(RiskChart)
admin.site.register(Result)
admin.site.register(Appointment)
admin.site.register(Configuration)
