# frozen_string_literal: true

module SystemSpecHelper
  def sign_in_as(user)
    session = { user_id: user.id }
    allow_any_instance_of(ActionDispatch::Request).to receive(:session).and_return(session)
    user.update!(expires_at: 3.hours.from_now)
    session
  end
end
