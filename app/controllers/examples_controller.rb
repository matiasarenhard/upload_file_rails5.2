class ExamplesController < ApplicationController
  before_action :set_example, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:index, :edit, :update, :destroy]

  # GET /examples
  # GET /examples.json
  def index
    @examples = Example.all
  end

  # GET /examples/1
  # GET /examples/1.json
  def show
  end

  # GET /examples/new
  def new
    @example = Example.new
  end

  # GET /examples/1/edit
  def edit
  end

  # POST /examples
  # POST /examples.json
  def create
    if params[:file].nil? == true
       flash[:notice] = "Please, select .tab file for upload"
       redirect_to :examples
       return
    end
    File.foreach(params[:file].path).with_index do |line, index|
      if index > 0
         aux = line.split(/\t/)
         example = Example.new
         example.purchaser_name = aux[0]
         example.item_description = aux[1]
         example.item_price = aux[2]
         example.purchase_count = aux[3]
         example.merchant_address = aux[4]
         example.merchant_name = aux[5]
         example.save
      end
    end
    flash[:notice] = "Successfully uploaded"
    redirect_to :examples
  end

  # PATCH/PUT /examples/1
  # PATCH/PUT /examples/1.json
  def update
    respond_to do |format|
      if @example.update(example_params)
        format.html { redirect_to :examples, notice: 'Example was successfully updated.' }
      else
        format.html { render :edit }
        format.json { render json: @example.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /examples/1
  # DELETE /examples/1.json
  def destroy
    @example.destroy
    respond_to do |format|
      format.html { redirect_to examples_url, notice: 'Example was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_example
      @example = Example.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def example_params
      params.require(:example).permit(:purchaser_name, :item_description, :item_price, :purchase_count, :merchant_address, :merchant_name, :file)
    end
end
