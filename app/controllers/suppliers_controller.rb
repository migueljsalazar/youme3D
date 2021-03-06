class SuppliersController < ApplicationController
 before_action :set_designer, only: [:show, :edit, :update, :destroy]

  def new
    if current_supplier
      redirect_to root_path
    else
    @supplier = Supplier.new
  end
  end

  def create
    @supplier = Supplier.new supplier_params

    if @supplier.save
      redirect_to root_path, notice: "Created Supplier"
    else
      render action: "new"
    end
  end

  private
  def set_supplier
      @supplier = current_supplier.find(params[:id])
  end

  def supplier_params
    params.
      require(:supplier).
      permit(:username, :password, :email, :password_confirmation, :company_name, :address, :zip_code, :price_per_cm3, :city)
  end

end
