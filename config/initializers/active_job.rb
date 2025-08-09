require "solid_flow"

Rails.application.config.active_job.custom_serializers << SolidFlow::CursorSerializer
