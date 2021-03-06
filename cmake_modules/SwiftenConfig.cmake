FIND_LIBRARY(SWIFTEN_LIBRARY NAMES Swiften)
FIND_PATH(SWIFTEN_INCLUDE_DIR NAMES "Swiften.h" PATH_SUFFIXES libSwiften Swiften )

if( SWIFTEN_LIBRARY AND SWIFTEN_INCLUDE_DIR )
	find_program(SWIFTEN_CONFIG_EXECUTABLE NAMES swiften-config DOC "swiften-config executable")
	set( SWIFTEN_CFLAGS "" )
	if (SWIFTEN_CONFIG_EXECUTABLE)
		execute_process(
			COMMAND ${SWIFTEN_CONFIG_EXECUTABLE} --libs
			OUTPUT_VARIABLE SWIFTEN_LIB)
		string(REGEX REPLACE "[\r\n]"                  " " SWIFTEN_LIB ${SWIFTEN_LIB})
		string(REGEX REPLACE " +$"                     ""  SWIFTEN_LIB ${SWIFTEN_LIB})
		string(REGEX REPLACE " " ";" SWIFTEN_LIB ${SWIFTEN_LIB})
		set(SWIFTEN_LIBRARY "")
		foreach(f ${SWIFTEN_LIB})
			STRING(SUBSTRING ${f} 0 2 f_out)
			STRING(COMPARE EQUAL ${f_out} "/L" IS_PATH)
			if(${IS_PATH})
				string(REGEX REPLACE "/LIBPATH:" ""  f_replaced "${f}")
				message("Added link directory: ${f_replaced}")
				link_directories(${f_replaced})
			else()
				list(APPEND SWIFTEN_LIBRARY ${f})
			endif()
		endforeach(f) 
	else()
		message( FATAL_ERROR "Could NOT find swiften-config" )
	endif()

	set( SWIFTEN_INCLUDE_DIR ${SWIFTEN_INCLUDE_DIR}/.. )
	message( STATUS "Found libSwiften: ${SWIFTEN_LIBRARY}, ${SWIFTEN_INCLUDE_DIR}")
	set( SWIFTEN_FOUND 1 )
else( SWIFTEN_LIBRARY AND SWIFTEN_INCLUDE_DIR )
    message( FATAL_ERROR "Could NOT find libSwiften" )
endif( SWIFTEN_LIBRARY AND SWIFTEN_INCLUDE_DIR )
