from django.contrib import admin

from .models import Topic, Post


@admin.register(Topic)
class TopicAdmin(admin.ModelAdmin):
    pass


@admin.register(Post)
class PostAdmin(admin.ModelAdmin):
    pass
