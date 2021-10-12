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

#' Import MMASH RR data
#'
#' @param file_path Path to RR data
#'
#' @return Output a data frame/Tibble
#'
import_RR_data <- function(file_path) {
    RR_data <- vroom::vroom(
        file_path,
        col_select = -1,
        col_types = vroom::cols(
            ibi_s = vroom::col_double(),
            day = vroom::col_double(),
            time = vroom::col_time(format = "")  #if time format are giving problems this will help
        ),
        .name_repair = snakecase::to_snake_case
    )
    return(RR_data)
}

#' Import MMASH Actigraph data
#'
#' @param file_path Path to Actigraph data
#'
#' @return Output a data frame/Tibble
#'
import_Actigraph_data <- function(file_path) {
    Actigraph_data <- vroom::vroom(
        file_path,
        col_select = -1,
        col_types = vroom::cols(
            axis_1 = vroom::col_double(),
            axis_2 = vroom::col_double(),
            axis_3 = vroom::col_double(),
            steps = vroom::col_double(),
            hr = vroom::col_double(),
            inclinometer_off = vroom::col_double(),
            inclinometer_standing = vroom::col_double(),
            inclinometer_sitting = vroom::col_double(),
            inclinometer_lying = vroom::col_double(),
            vector_magnitude = vroom::col_double(),
            day = vroom::col_double(),
            time = vroom::col_time(format = "")
        ),
        .name_repair = snakecase::to_snake_case
    )
    return(Actigraph_data)
}

#'Import multiple data frames
#'
#' @param file_pattern Path to the user file f.ex. *.csv
#' @param import_function Earlier imported data
#'
#' @return The combined data table
#'
import_multiple_files <- function(file_pattern, import_function) {
    data_files <- fs::dir_ls(here("data-raw/mmash/"),
                             recurse = TRUE,
                             regexp = file_pattern)

    combined_data <- purrr::map_dfr(data_files,
                                    import_function,
                                    .id = "file_path_id")

    return(combined_data)
}
