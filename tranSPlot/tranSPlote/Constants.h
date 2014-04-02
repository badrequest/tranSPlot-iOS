//
//  Constants.h
//  tranSPlot
//
//  Created by Fabio Dela Antonio on 3/22/14.
//  Copyright (c) 2014 Bad Request. All rights reserved.
//

#ifndef tranSPlot_Constants_h
#define tranSPlot_Constants_h

#define ERROR_ALERT(X) \
[[[UIAlertView alloc] initWithTitle:@"Erro!" \
message:X \
delegate:nil \
cancelButtonTitle:@"OK" \
otherButtonTitles:nil] show]

#define ALERT(X, Y)  \
[[[UIAlertView alloc] initWithTitle:X \
message:Y \
delegate:nil \
cancelButtonTitle:@"OK" \
otherButtonTitles:nil] show]

#define GPS_TIMEOUT 15.0
#define MAX_GPS_TRIES 5
#define MAX_GPS_ACCURACY 10.0

/* #warning TROCAR ESTE PELO ENDERECO DO SEU WEBSERVICE */
#define WEB_SERVICE_SERVER @"54.201.69.11/transplot-rest/rest"

/* Definições do mapa */

/* Coordenada inicial */
#define COORD_I_Y -23.805917
#define COORD_I_X -46.862748

/* Coordenada final */
#define COORD_F_Y -23.350221
#define COORD_F_X -46.371981

/* Tamanho de um bloco do "grid" */
#define BLOCK_SIZE 10.0 /* m */

#endif
