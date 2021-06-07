class ToolsController < ApplicationController
  before_action :set_tool, only: %i[show edit update destroy]

  # GET /tools or /tools.json
  def index
    @tools = Tool.all
  end

  # GET /tools/1 or /tools/1.json
  def show; end

  # GET /tools/new
  def new
    @tool = Tool.new
  end

  # GET /tools/1/edit
  def edit; end

  # POST /tools or /tools.json
  def create
    @tool = Tool.new(tool_params)
    @tool_fetch = GithubManager::ToolFetcher.call @tool

    respond_to do |format|
      if @tool_fetch.success
        @tool.json_spec = @tool_fetch.json_raw
        if @tool.save
          format.html { redirect_to @tool, notice: 'Tool was successfully created.' }
          format.json { render :show, status: :created, location: @tool }
        end
      elsif @tool_fetch.json_invalid
        @tool.errors.add :json_spec, :invalid, message: "#{@tool_fetch.path} format is invalid"
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @tool.errors, status: :unprocessable_entity }
      else
        @tool.errors.add :json_spec, :invalid, message: "#{@tool_fetch.path} failed to download"
        format.html { render :new, status: :internal_server_error }
        format.json { render json: @tool.errors, status: :internal_server_error }
      end
    end
  end

  # PATCH/PUT /tools/1 or /tools/1.json
  def update
    respond_to do |format|
      if @tool.update(tool_params)
        format.html { redirect_to @tool, notice: 'Tool was successfully updated.' }
        format.json { render :show, status: :ok, location: @tool }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @tool.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tools/1 or /tools/1.json
  def destroy
    @tool.destroy
    respond_to do |format|
      format.html { redirect_to tools_url, notice: 'Tool was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_tool
    @tool = Tool.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def tool_params
    params.require(:tool).permit(:name, :language, :json_spec)
  end
end
