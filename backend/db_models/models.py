from django.db import models
from django.contrib.auth.models import AbstractUser
from django.conf import settings


# ✅ Custom User
class CustomUser(AbstractUser):
    middle_name = models.CharField(max_length=100, blank=True, null=True)
    suffix = models.CharField(max_length=50, blank=True, null=True)
    age = models.IntegerField(blank=True, null=True)
    sex = models.CharField(
        max_length=10,
        choices=[("Male", "Male"), ("Female", "Female")],
        blank=True,
        null=True,
    )
    phone_number = models.CharField(max_length=20, blank=True, null=True)
    location = models.CharField(max_length=255, blank=True, null=True)
    status = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.username


# ✅ Barangays & RHUs
class Barangay(models.Model):
    barangay_name = models.CharField(max_length=100, unique=True)
    municipality = models.CharField(max_length=100, default="General Mariano Alvarez")
    province = models.CharField(max_length=100, default="Cavite")
    region = models.CharField(max_length=100, default="Region IV-A")

    def __str__(self):
        return self.barangay_name


class RuralHealthUnit(models.Model):
    rhu_name = models.CharField(max_length=100, unique=True)
    barangay = models.ForeignKey(Barangay, on_delete=models.CASCADE)

    def __str__(self):
        return self.rhu_name


# ✅ Activity Logs
class ActivityLog(models.Model):
    time = models.DateTimeField(auto_now_add=True)
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    log_details = models.TextField()
    action = models.CharField(max_length=255)


# ✅ Quota
class Quota(models.Model):
    date = models.DateTimeField(auto_now_add=True)
    quota_limit = models.IntegerField()
    daily_assessment_data = models.IntegerField()
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)


# ✅ Patients
class PatientInformation(models.Model):
    name = models.CharField(max_length=100)
    birthdate = models.DateField()
    age = models.IntegerField()
    sex = models.CharField(max_length=10, choices=[("Male", "Male"), ("Female", "Female")])
    civil_status = models.CharField(
        max_length=20,
        choices=[
            ("Single", "Single"),
            ("Married", "Married"),
            ("Widowed", "Widowed"),
            ("Separated", "Separated"),
        ],
    )
    contact_num = models.CharField(max_length=20)
    address = models.CharField(max_length=255)
    barangay = models.CharField(max_length=100)

    def __str__(self):
        return self.name


# ✅ Assessments
class Assessment(models.Model):
    assessment_date_time = models.DateTimeField(auto_now_add=True)
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    patient = models.ForeignKey(PatientInformation, on_delete=models.CASCADE)
    is_completed = models.BooleanField(default=False)
    is_archived = models.BooleanField(default=False)
    is_synced = models.BooleanField(default=False)


# ✅ Intake Record
class PatientIntakeRecord(models.Model):
    patient = models.ForeignKey(PatientInformation, on_delete=models.CASCADE)
    hypertension = models.BooleanField()
    stroke = models.BooleanField()
    heart_attack = models.BooleanField()
    diabetes = models.BooleanField()
    asthma = models.BooleanField()
    cancer = models.BooleanField()
    kidney_disease = models.BooleanField()
    height = models.IntegerField()
    weight = models.IntegerField()
    bmi = models.FloatField()
    bmi_category = models.CharField(max_length=50)
    obesity = models.BooleanField()
    waist_circumference = models.IntegerField()
    hip_circumference = models.IntegerField()
    whr_ratio = models.FloatField()
    whr_category = models.CharField(max_length=50)
    central_adiposity = models.BooleanField()
    first_sbp = models.IntegerField()
    first_dbp = models.IntegerField()
    second_sbp = models.IntegerField()
    second_dbp = models.IntegerField()
    avg_sbp = models.IntegerField()
    avg_dbp = models.IntegerField()
    bp_category = models.CharField(max_length=50)
    raised_bp = models.BooleanField()
    existing_medication = models.CharField(max_length=100, blank=True, null=True)
    medicine_mg = models.IntegerField(blank=True, null=True)
    smoking_status = models.CharField(max_length=50)
    drinks_alcohol = models.CharField(max_length=50)
    excessive_alcohol_use = models.CharField(max_length=50)
    high_fat_salt_intake = models.CharField(max_length=50)
    vegetable_intake = models.CharField(max_length=50)
    fruit_intake = models.CharField(max_length=50)
    physical_activity = models.CharField(max_length=50)


# ✅ Screening
class PatientScreening(models.Model):
    patient_intake_record = models.ForeignKey(PatientIntakeRecord, on_delete=models.CASCADE)
    question_one = models.BooleanField()
    question_two = models.BooleanField(blank=True, null=True)
    question_three = models.BooleanField(blank=True, null=True)
    question_four = models.BooleanField(blank=True, null=True)
    question_five = models.BooleanField(blank=True, null=True)
    question_six = models.BooleanField(blank=True, null=True)
    question_seven = models.BooleanField(blank=True, null=True)
    possible_angina_heart_attack = models.BooleanField()
    question_eight = models.BooleanField()
    possible_stroke_tia = models.BooleanField()
    is_diagnosed_diabetes = models.CharField(max_length=50)
    with_without_medication = models.CharField(max_length=50, blank=True, null=True)
    existing_diabetes_medicines = models.CharField(max_length=100, blank=True, null=True)
    diabetes_med_milligrams = models.IntegerField(blank=True, null=True)
    have_polyphagia = models.BooleanField()
    have_polydipsia = models.BooleanField()
    have_polyuria = models.BooleanField()


# ✅ Risk
class RiskLevel(models.Model):
    risk_level = models.CharField(max_length=50)
    risk_color = models.CharField(max_length=50)
    risk_label = models.CharField(max_length=20, blank=True, null=True)

    def __str__(self):
        return self.risk_level


class RiskChart(models.Model):
    sex = models.CharField(max_length=10)
    age_group = models.CharField(max_length=50)
    smoker_status = models.CharField(max_length=50)
    bmi_group = models.CharField(max_length=50)
    sbp_group = models.CharField(max_length=50)
    risk_percentage = models.IntegerField()
    risk_level = models.ForeignKey(RiskLevel, on_delete=models.CASCADE)

    class Meta:
        unique_together = ("sex", "age_group", "smoker_status", "bmi_group", "sbp_group")

    @classmethod
    def lookup(cls, sex, age_group, smoker_status, bmi_group, sbp_group):
        return cls.objects.filter(
            sex=sex,
            age_group=age_group,
            smoker_status=smoker_status,
            bmi_group=bmi_group,
            sbp_group=sbp_group,
        ).first()


# ✅ Recommendations
class Recommendation(models.Model):
    feature = models.CharField(max_length=50)
    recommendation = models.TextField()


# ✅ Results
class Result(models.Model):
    assessment = models.ForeignKey(Assessment, on_delete=models.CASCADE)
    risk_result = models.ForeignKey(RiskChart, on_delete=models.CASCADE)
    recommendation = models.ForeignKey(Recommendation, on_delete=models.CASCADE)


# ✅ Appointments
class Appointment(models.Model):
    assessment = models.ForeignKey(Assessment, on_delete=models.CASCADE)
    health_provider = models.CharField(max_length=50)
    date_time = models.DateTimeField()
    rhu = models.CharField(max_length=50)
    is_completed = models.BooleanField(default=False)


# ✅ Configuration
class Configuration(models.Model):
    sms_notification = models.BooleanField()
    email_notification = models.BooleanField()
