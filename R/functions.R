#' Import MMASH user info data file.
#'
#' @param file_path Path to user info data file.
#'
#' @return Output a data frame/tibble.
#'
import_user_info <- function(file_path) {
    info_data <- vroom::vroom(
        file_path,
        col_select = -1,
        col_types = vroom::cols(
            gender = vroom::col_character(),
            weight = vroom::col_double(),
            height = vroom::col_double(),
            age = vroom::col_double(),
            .delim = ","
        ),
        .name_repair = snakecase::to_snake_case
    )
    return(info_data)
}

#' Import MMASH Saliva data
#'
#' @param file_path Path to saliva data
#'
#' @return Output a data frame/Tibble
#'
import_saliva_data <- function(file_path) {
    saliva_data <- vroom::vroom(
        file_path,
        col_select = -1,
        col_types = vroom::cols(
            samples = vroom::col_character(),
            cortisol_norm = vroom::col_double(),
            melatonin_norm = vroom::col_double()
        ),
        .name_repair = snakecase::to_snake_case
    )
    return(saliva_data)
}
