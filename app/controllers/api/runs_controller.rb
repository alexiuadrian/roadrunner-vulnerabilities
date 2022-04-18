class Api::RunsController < Api::BaseController
  def index
    # Filtering by date
    if params[:from_date] && params[:to_date]
      @runs = policy_scope(Run).where(date: params[:from_date]..params[:to_date])
    else
      @runs = policy_scope(Run).all
    end

    authorize @runs

    respond_to do |format|
      format.json { render json: @runs }
    end
  end

  def create
    @run = Run.new(run_params)

    authorize @run

    hours_minutes = run_params[:time].to_s.split
    average_speed = run_params[:distance] / (hours_minutes[0].to_f + hours_minutes[1].to_f / 60)
    @run.average_speed = average_speed
    respond_to do |format|
      if @run.save
        format.json { render json: { "OK": true } }
      else
        format.json { render json: { "OK": false } }
      end
    end
  end

  def show
    set_run
    authorize @run
    respond_to do |format|
      format.json { render json: @run }
    end
  end

  def update
    set_run
    authorize @run

    respond_to do |format|
      if @run.update(run_params)
        format.json { render json: @run }
      else
        format.json { render json: @run.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    id = params[:id]

    res = Run.where("id = #{id} AND user_id = #{current_user.id}").delete_all

    respond_to do |format|
      if res > 0
        format.json { render json: "record deleted" }
      else
        format.json { render json: "record not found" }
      end
    end
  end

  def report
    today = Date.today
    @runs = policy_scope(Run).all.where(date: (today.at_beginning_of_week - 1.day)..(today.at_end_of_week + 1.day))
    authorize @runs

    average_speeds = []
    distances = []
    @runs.each do |run|
      average_speeds.push(run.average_speed)
      distances.push(run.distance)
    end

    average_speed_per_week = average_speeds.sum(0.0) / average_speeds.size
    average_distance_per_week = distances.sum(0.0) / distances.size

    respond_to do |format|
      format.json {
        render json: {
                 'average_speed': average_speed_per_week.round(2),
                 'average_distance': average_distance_per_week.round(2),
               }
      }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_run
    @run = policy_scope(Run).find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def run_params
    params.require(:run).permit(:date, :distance, :time, :user_id, :from_date, :to_date)
  end
end
