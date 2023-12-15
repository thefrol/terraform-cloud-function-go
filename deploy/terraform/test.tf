terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

variable "function_zip" {
  description="путь к архиву с функцией"
  type = string
  default="default"
}

provider "yandex" {
  zone = "a"

  service_account_key_file="${file("key.json")}"
  cloud_id="b1gfdklnihumm66v7768"
  folder_id="b1gdimk0to2b6b0gl9vd"

}
resource "yandex_function" "test-function" {
    name               = "test-function2"
    description        = "Test function"
    user_hash          = "first-function3" # офигенная тема, тут можно указать хеш по которому будут обновляться функции
    runtime            = "golang121"
    entrypoint         = "cmd/function/main.Handler" # нужно указать ещё файл!
    memory             = "128" 
    execution_timeout  = "10"
    # service_account_id = "<идентификатор сервисного аккаунта>"
    content {
        zip_filename = var.function_zip
    }
}

## make public 

## requires role more tha editor

## Причем галочка не стоит, что функция публичная, но она публичная))

resource "yandex_function_iam_binding" "function-iam" {
  function_id = yandex_function.test-function.id
  role        = "functions.functionInvoker"
  members = [
    "system:allUsers",
  ]
}

output "test_func_url" {
    value = "https://functions.yandexcloud.net/${yandex_function.test-function.id}"
}