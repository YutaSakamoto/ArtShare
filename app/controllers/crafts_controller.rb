class CraftsController < ApplicationController
    before_action :set_craft, except: [:index, :new, :create]
    before_action :authenticate_user!, except: [:show]
    before_action :is_authorised, only: [:listing, :pricing, :description, :photo_upload, :amenities, :location, :update]

    def index
      @crafts = current_user.crafts
    end

    def new
      @craft = current_user.crafts.build
    end

    def create
      if !current_user.is_active_host
        return redirect_to payout_method_path, alert: "Please Connect to Stripe Express first."
      end
      
      @craft = current_user.crafts.build(craft_params)
      if @craft.save
        redirect_to listing_craft_path(@craft), notice: "Saved..."
      else
        flash[:alert] = "Something went wrong..."
        render :new
      end
    end


    def show
      @photos = @craft.photos
      @guest_reviews = @craft.guest_reviews
    end

    def listing
    end

    def pricing
    end

    def description
    end

    def photo_upload
      @photos = @craft.photos
    end

    def amenities
    end

    def location
    end

    def update

      new_params = craft_params
      new_params = craft_params.merge(active: true) if is_ready_craft

      if @craft.update(new_params)
        flash[:notice] = "Saved..."
      else
        flash[:alert] = "Something went wrong..."
      end
      redirect_back(fallback_location: request.referer)
    end

    # --- Reservations ---
    def preload
      today = Date.today
      reservations = @craft.reservations.where("(start_date >= ? OR end_date >= ?) AND status = ?", today, today, 1)
      unavailable_dates = @craft.calendars.where("status = ? AND day > ?", 1, today)

      special_dates = @craft.calendars.where("status = ? AND day > ? AND price <> ?",0, today, @craft.price)

      render json: {
          reservations: reservations,
          unavailable_dates: unavailable_dates,
          special_dates: special_dates
      }
    end

    def preview
      start_date = Date.parse(params[:start_date])
      end_date = Date.parse(params[:end_date])

      output = {
        conflict: is_conflict(start_date, end_date, @craft)
      }

      render json: output
    end

    private
      def is_conflict(start_date, end_date, craft)
        check = craft.reservations.where("(? < start_date AND end_date < ?) AND status = ?", start_date, end_date, 1)
        check_2 = craft.calendars.where("day BETWEEN ? AND ? AND status = ?", start_date, end_date, 1).limit(1)

        check.size > 0 || check_2.size > 0 ? true : false
      end

      def set_craft
        @craft = Craft.find(params[:id])
      end

      def is_authorised
        redirect_to root_path, alert: "You don't have permission" unless current_user.id == @craft.user_id
      end

      def is_ready_craft
        !@craft.active && !@craft.price.blank? && !@craft.listing_name.blank? && !@craft.photos.blank? && !@craft.address.blank?
      end

      def craft_params
        params.require(:craft).permit(:listing_name, :summary, :address, :price, :active, :instant)
      end
  end
