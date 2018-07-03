module Response
  def json_response(object, status = :ok)
    if status == :ok or status == :created
      render json: { "data" => object.as_json(:root => false), "status": "ok" }.to_json, status: status
    else 
      render json: object, status: status
    end
  end
end
