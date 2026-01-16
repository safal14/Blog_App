class ApplicationController < ActionController::Base
  include Pundit::Authorization
   before_action :configure_permitted_parameters, if: :devise_controller?
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes
 

  # ... your existing code (configure_permitted_parameters, after_sign_in_path_for etc.) ...
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
protected
def after_sign_in_path_for(resource)
    "/"    # ← goes to your root route (e.g. homepage)
  end
  def configure_permitted_parameters
  devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])
  devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name])
end


 private
def user_not_authorized(exception)
  action = exception.query
  record = exception.record

  # Get the correct policy instance
  policy = Pundit.policy!(current_user, record)

  # Call error_message if defined
  message =
    if policy.respond_to?(:error_message)
      policy.error_message(action)
    else
      "You are not authorized to perform #{action.to_s.chomp('?')}."
    end

  redirect_back fallback_location: root_path, alert: message
end

end