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
end

 private

  def user_not_authorized(exception)
  # More helpful messages depending on what was denied
  message = case exception.query.to_s
            when "index?", "show?"
              "You don't have permission to view this content."
            when "new?", "create?"
              "Only authors and administrators can create new posts."
            when "edit?", "update?"
              "You can only edit your own posts (or you need admin rights)."
            when "destroy?"
              "You can only delete your own posts."
            else
              "You are not authorized to perform this action."
            end

  flash[:alert] = message
  redirect_to(request.referrer || root_path)
end