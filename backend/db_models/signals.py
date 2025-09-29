from django.db.models.signals import post_migrate
from django.dispatch import receiver
from django.contrib.auth.models import Group, Permission


@receiver(post_migrate)
def create_default_groups(sender, **kwargs):
    if sender.label != "db_models":
        return

    groups = ["Admin", "Municipal Health Worker", "Barangay Health Worker"]
    for name in groups:
        Group.objects.get_or_create(name=name)

    admin_group = Group.objects.get(name="Admin")
    admin_group.permissions.set(Permission.objects.all())

    mhw_group = Group.objects.get(name="Municipal Health Worker")
    mhw_perms = Permission.objects.filter(content_type__app_label="db_models")
    mhw_group.permissions.set(mhw_perms)

    bhw_group = Group.objects.get(name="Barangay Health Worker")
    bhw_group.permissions.clear()