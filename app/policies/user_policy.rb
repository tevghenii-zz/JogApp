class ArticlePolicy < ApplicationPolicy
  def update?
    user.role? :admin or not record.published?
  end
end