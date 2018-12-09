class Reservation < ApplicationRecord
  enum status: {Waiting: 0, Approved: 1, Declined: 2}

  belongs_to :user
  belongs_to :craft

  scope :current_week_revenue, -> (user) {
    joins(:craft)
    .where("crafts.user_id = ? AND reservations.updated_at >= ? AND reservations.status = ?", user.id, 1.week.ago, 1)
    .order(updated_at: :asc)
  }

  private
    def create_notification
      guest = User.find(self.user_id)

      Notification.create(content: "New Booking from #{guest.fullname}", user_id: self.motorbike.user_id)
    end
end
