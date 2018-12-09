class ReservationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_reservation, only: [:approve, :decline]

  def create
    craft = Craft.find(params[:craft_id])

    if current_user == craft.user
      flash[:alert] = "You cannot book your own property!"
    elsif current_user.stripe_id.blank?
      flash[:alert] = "Please update your payment method."
      return redirect_to payment_method_path
    else
      start_date = Date.parse(reservation_params[:start_date])
      end_date = Date.parse(reservation_params[:end_date])
      days = (end_date - start_date).to_i + 1

      special_dates = craft.calendars.where(
        "status = ? AND day BETWEEN ? AND ? AND price <> ?",
        0, start_date, end_date, craft.price
      )

      @reservation = current_user.reservations.build(reservation_params)
      @reservation.craft = craft
      @reservation.price = craft.price
      # @reservation.total = craft.price * days
      # @reservation.save

      @reservation.total = craft.price * (days - special_dates.count)
      special_dates.each do |date|
          @reservation.total += date.price
      end

      if @reservation.Waiting!
        if craft.Request?
          flash[:notice] = "Request sent successfully!"
        else
          charge(craft, @reservation)
        end
      else
        flash[:alert] = "Cannot make a reservation!"
      end

    end
    redirect_to craft
  end

  def your_lendings
    @trips = current_user.reservations.order(start_date: :asc)
  end

  def your_reservations
    @crafts = current_user.crafts
  end

  def approve
    charge(@reservation.craft, @reservation)
    @reservation.Approved!
    redirect_to your_reservations_path
  end

  def decline
    @reservation.Declined!
    redirect_to your_reservations_path
  end

  private
  def charge(craft, reservation)
    if !reservation.user.stripe_id.blank?
      customer = Stripe::Customer.retrieve(reservation.user.stripe_id)
      charge = Stripe::Charge.create(
        :customer => customer.id,
        :amount => reservation.total * 100,
        :description => craft.listing_name,
        :currency => "jpy",
        :destination => {
        :amount => reservation.total * 80, # 80% of the total amount goes to the Host
        :account => craft.user.merchant_id # Host's Stripe customer ID
      }

      )

      if charge
        reservation.Approved!
        flash[:notice] = "Reservation created successfully!"
      else
        reservation.Declined!
        flash[:alert] = "Cannot charge with this payment method!"
      end
    end
    rescue Stripe::CardError => e
    reservation.declined!
    flash[:alert] = e.message
    end


    def set_reservation
      @reservation = Reservation.find(params[:id])
    end

    def reservation_params
      params.require(:reservation).permit(:start_date, :end_date)
    end
end
