module ApplicationHelper
    def role_badge_class(role)
  case role
  when "admin"   then "bg-danger"
  when "author"  then "bg-success"
  when "reader"  then "bg-secondary"
  else "bg-dark"
  end
end
end
