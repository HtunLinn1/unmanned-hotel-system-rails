class HomeController < ApplicationController
  def index
    Booking.where("end_date < ?", Date.today).update_all(check_out:true, key:'*****', credit_no: '***************')
  end
end
