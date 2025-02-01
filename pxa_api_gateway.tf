resource "aws_api_gateway_rest_api" "api_gateway" {
  name = "${local.pxa_prefix}-api-gateway-event"
  tags = {
    Name        = "${local.pxa_prefix}-api-gateway-event"
    Project     = "${local.pxa_project_name}"
    Customer    = var.PROJECT_CUSTOMER
    Environment = var.PROJECT_ENV
    Terraform   = true
  }
}

# /api
resource "aws_api_gateway_resource" "api" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  parent_id   = aws_api_gateway_rest_api.api_gateway.root_resource_id
  path_part   = "api"
}

# /api/event
resource "aws_api_gateway_resource" "event" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  parent_id   = aws_api_gateway_resource.api.id
  path_part   = "event"
}

resource "aws_api_gateway_method" "event_post" {
  rest_api_id   = aws_api_gateway_rest_api.api_gateway.id
  resource_id   = aws_api_gateway_resource.event.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "event_post_200" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  resource_id = aws_api_gateway_resource.event.id
  http_method = aws_api_gateway_method.event_post.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_api_gateway_method_response" "event_post_400" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  resource_id = aws_api_gateway_resource.event.id
  http_method = aws_api_gateway_method.event_post.http_method
  status_code = "400"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_api_gateway_method_response" "event_post_401" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  resource_id = aws_api_gateway_resource.event.id
  http_method = aws_api_gateway_method.event_post.http_method
  status_code = "401"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_api_gateway_method_response" "event_post_403" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  resource_id = aws_api_gateway_resource.event.id
  http_method = aws_api_gateway_method.event_post.http_method
  status_code = "403"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_api_gateway_method_response" "event_post_500" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  resource_id = aws_api_gateway_resource.event.id
  http_method = aws_api_gateway_method.event_post.http_method
  status_code = "500"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_api_gateway_integration" "event_post" {
  rest_api_id             = aws_api_gateway_rest_api.api_gateway.id
  resource_id             = aws_api_gateway_resource.event.id
  http_method             = aws_api_gateway_method.event_post.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:${var.AWS_REGION}:lambda:path/2015-03-31/functions/${aws_lambda_function.event.arn}/invocations"

  request_templates = {
    "application/json"                  = file("${path.module}/templates/request_template_application_json.txt")
    "application/x-www-form-urlencoded" = file("${path.module}/templates/request_template_application_x_www_form_urlencoded.txt")
  }

  passthrough_behavior = "NEVER"
}

resource "aws_api_gateway_integration_response" "event_post_200" {
  depends_on  = [aws_api_gateway_integration.event_post]
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  resource_id = aws_api_gateway_resource.event.id
  http_method = aws_api_gateway_method.event_post.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }

  response_templates = {
    "application/json" = <<EOF
#set($inputRoot = $input.path('$'))
$inputRoot.body
EOF
  }
}

resource "aws_api_gateway_integration_response" "event_post_400" {
  depends_on        = [aws_api_gateway_integration.event_post]
  rest_api_id       = aws_api_gateway_rest_api.api_gateway.id
  resource_id       = aws_api_gateway_resource.event.id
  http_method       = aws_api_gateway_method.event_post.http_method
  status_code       = "400"
  selection_pattern = ".*.400.*"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }

  response_templates = {
    "application/json" = <<EOF
#set ($errorMessageObj = $util.parseJson($input.path('$.errorMessage')))
$errorMessageObj.body
EOF
  }
}

resource "aws_api_gateway_integration_response" "event_post_401" {
  depends_on        = [aws_api_gateway_integration.event_post]
  rest_api_id       = aws_api_gateway_rest_api.api_gateway.id
  resource_id       = aws_api_gateway_resource.event.id
  http_method       = aws_api_gateway_method.event_post.http_method
  status_code       = "401"
  selection_pattern = ".*.401.*"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }

  response_templates = {
    "application/json" = <<EOF
#set ($errorMessageObj = $util.parseJson($input.path('$.errorMessage')))
$errorMessageObj.body
EOF
  }
}

resource "aws_api_gateway_integration_response" "event_post_403" {
  depends_on        = [aws_api_gateway_integration.event_post]
  rest_api_id       = aws_api_gateway_rest_api.api_gateway.id
  resource_id       = aws_api_gateway_resource.event.id
  http_method       = aws_api_gateway_method.event_post.http_method
  status_code       = "403"
  selection_pattern = ".*.403.*"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }

  response_templates = {
    "application/json" = <<EOF
#set ($errorMessageObj = $util.parseJson($input.path('$.errorMessage')))
$errorMessageObj.body
EOF
  }
}

resource "aws_api_gateway_integration_response" "event_post_500" {
  depends_on        = [aws_api_gateway_integration.event_post]
  rest_api_id       = aws_api_gateway_rest_api.api_gateway.id
  resource_id       = aws_api_gateway_resource.event.id
  http_method       = aws_api_gateway_method.event_post.http_method
  status_code       = "500"
  selection_pattern = ".*.500.*"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }

  response_templates = {
    "application/json" = <<EOF
#set ($errorMessageObj = $util.parseJson($input.path('$.errorMessage')))
$errorMessageObj.body
EOF
  }
}

# /api/authenticate
resource "aws_api_gateway_resource" "authenticate_resource" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  parent_id   = aws_api_gateway_resource.api.id
  path_part   = "authenticate"
}

resource "aws_api_gateway_method" "authenticate_method" {
  rest_api_id   = aws_api_gateway_rest_api.api_gateway.id
  resource_id   = aws_api_gateway_resource.authenticate_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "authenticate_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api_gateway.id
  resource_id             = aws_api_gateway_resource.authenticate_resource.id
  http_method             = aws_api_gateway_method.authenticate_method.http_method
  integration_http_method = "POST"
  type                    = "HTTP_PROXY"
  uri                     = var.api_gateway.authenticate_uri
}

# /api/geolocation
resource "aws_api_gateway_resource" "geolocation_resource" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  parent_id   = aws_api_gateway_resource.api.id
  path_part   = "geolocation"
}

resource "aws_api_gateway_method" "geolocation_method" {
  rest_api_id   = aws_api_gateway_rest_api.api_gateway.id
  resource_id   = aws_api_gateway_resource.geolocation_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "geolocation_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api_gateway.id
  resource_id             = aws_api_gateway_resource.geolocation_resource.id
  http_method             = aws_api_gateway_method.geolocation_method.http_method
  integration_http_method = "GET"
  type                    = "HTTP_PROXY"
  uri                     = var.api_gateway.geolocation_uri
}

# CORS for /event
resource "aws_api_gateway_method" "event_options" {
  rest_api_id   = aws_api_gateway_rest_api.api_gateway.id
  resource_id   = aws_api_gateway_resource.event.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "event_options_200" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  resource_id = aws_api_gateway_resource.event.id
  http_method = aws_api_gateway_method.event_options.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration" "event_options_integration" {
  rest_api_id          = aws_api_gateway_rest_api.api_gateway.id
  resource_id          = aws_api_gateway_resource.event.id
  http_method          = aws_api_gateway_method.event_options.http_method
  type                 = "MOCK"
  passthrough_behavior = "WHEN_NO_MATCH"
  content_handling     = "CONVERT_TO_TEXT"

  request_templates = {
    "application/json" = jsonencode({
      statusCode = 200
    })
  }
}

resource "aws_api_gateway_integration_response" "authenticate_options_integration_response" {
  depends_on  = [aws_api_gateway_integration.authenticate_options_integration]
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  resource_id = aws_api_gateway_resource.authenticate_resource.id
  http_method = aws_api_gateway_method.authenticate_options.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'POST,OPTIONS'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  response_templates = {
    "application/json" = ""
  }
}

# Stage and Deployment
resource "aws_api_gateway_deployment" "deployment" {
  depends_on = [
    aws_api_gateway_integration.event_post,
    aws_api_gateway_integration.authenticate_integration,
    aws_api_gateway_integration.geolocation_integration,
    aws_api_gateway_integration.event_options_integration,
    aws_api_gateway_integration.authenticate_options_integration,
    aws_api_gateway_integration_response.event_post_200,
    aws_api_gateway_integration_response.event_post_400,
    aws_api_gateway_integration_response.event_post_401,
    aws_api_gateway_integration_response.event_post_403,
    aws_api_gateway_integration_response.event_post_500,
    aws_api_gateway_integration_response.event_options_integration_response,
    aws_api_gateway_integration_response.authenticate_options_integration_response
  ]
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id

  # Add lifecycle block to handle deployment updates
  lifecycle {
    create_before_destroy = true
  }

  # Add triggers to force new deployment when integrations change
  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_integration.event_post,
      aws_api_gateway_integration.authenticate_integration,
      aws_api_gateway_integration.geolocation_integration,
      aws_api_gateway_integration.event_options_integration,
      aws_api_gateway_integration.authenticate_options_integration
    ]))
  }
}

resource "aws_api_gateway_stage" "dev_stage" {
  depends_on    = [aws_api_gateway_deployment.deployment]
  rest_api_id   = aws_api_gateway_rest_api.api_gateway.id
  deployment_id = aws_api_gateway_deployment.deployment.id
  stage_name    = "dev"

  # Add cache settings if needed
  cache_cluster_enabled = false
  # cache_cluster_size   = "0.5"  # Uncomment if you want to enable caching

  # Add logging settings
  xray_tracing_enabled = true

  # Add method settings for better control
  variables = {
    "deployed_at" = timestamp()
  }

  tags = {
    Name        = "${local.pxa_prefix}-event-api-dev"
    Project     = "${local.pxa_project_name}"
    Customer    = var.PROJECT_CUSTOMER
    Environment = var.PROJECT_ENV
    Terraform   = true
  }
}

resource "aws_api_gateway_integration_response" "event_options_integration_response" {
  depends_on  = [aws_api_gateway_integration.event_options_integration]
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  resource_id = aws_api_gateway_resource.event.id
  http_method = aws_api_gateway_method.event_options.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'POST,OPTIONS'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  response_templates = {
    "application/json" = ""
  }
}

# CORS for /authenticate
resource "aws_api_gateway_method" "authenticate_options" {
  rest_api_id   = aws_api_gateway_rest_api.api_gateway.id
  resource_id   = aws_api_gateway_resource.authenticate_resource.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "authenticate_options_200" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  resource_id = aws_api_gateway_resource.authenticate_resource.id
  http_method = aws_api_gateway_method.authenticate_options.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration" "authenticate_options_integration" {
  rest_api_id          = aws_api_gateway_rest_api.api_gateway.id
  resource_id          = aws_api_gateway_resource.authenticate_resource.id
  http_method          = aws_api_gateway_method.authenticate_options.http_method
  type                 = "MOCK"
  passthrough_behavior = "WHEN_NO_MATCH"
  content_handling     = "CONVERT_TO_TEXT"

  request_templates = {
    "application/json" = jsonencode({
      statusCode = 200
    })
  }
}