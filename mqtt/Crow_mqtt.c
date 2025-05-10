#include <stdio.h>
#include <stdlib.h>
#include <mosquitto.h>
#include <sys/types.h> 
#include <sys/socket.h>
#include <netinet/in.h>
#include <string.h>
#include <netdb.h>
#include <signal.h>
#include <unistd.h>
#include <time.h>


#define DIE(msg) perror(msg); exit(1);



/*******************************************************/
/*                  Global Variable                    */
/*******************************************************/
int GF_forward_socket = -1 ;
char G_MQTT_topic_name[64] = {0} ;



/*******************************************************/
/*                        MQTT                         */
/*******************************************************/

void on_connect(struct mosquitto *mosq, void *obj, int rc) {
	fprintf( stdout , "ID: %d\n", * (int *) obj);
	if(rc) {
		fprintf( stdout ,"Error with result code: %d\n", rc);
		exit(-1);
	}
	mosquitto_subscribe(mosq, NULL, G_MQTT_topic_name , 0);
}

void on_message(struct mosquitto *mosq, void *obj, const struct mosquitto_message *msg) {
	fprintf( stdout ,"New message with topic %s: \"%s\"\n", msg->topic, (char *) msg->payload);
	if( GF_forward_socket > 0 ){
		write(GF_forward_socket,msg->payload,strlen(msg->payload));
	}
}


/*******************************************************/
/*                  Argument Parsing                   */
/*******************************************************/

void parse_arguments(int argc, char **argv, char * topic_name , int max_topic_size , int * socket_port ) {


    if (argc < 3) {
        fprintf(stderr, "Not enough arguments\n");
        exit(1);
    }


	strncpy(topic_name , argv[1] , max_topic_size);
    
    *socket_port = atoi(argv[2]);

    if ((*socket_port < 1) || (*socket_port >= 65535)) {
        fprintf(stderr, "Forwarding port is invalid\n");
        exit(1);
    }

}

/*******************************************************/
/*                   Time Management                   */
/*******************************************************/

void get_current_time(char *time_date , size_t max_size ){

	time_t rawtime;
    struct tm* timeinfo;
    char buffer [80];

    time(&rawtime);
    timeinfo = localtime(&rawtime);

    strftime(buffer,80,"%Y-%m-%d-%H-%M-%S",timeinfo);
    strncpy(time_date, buffer, max_size);

}



/*******************************************************/
/*                 PACKET Forwarding                   */
/*******************************************************/


int open_listening_port(int server_port) {

    struct sockaddr_in server_address;
    int server_socket;

    server_socket = socket(AF_INET, SOCK_STREAM, 0);

    if (server_socket == -1) {
        DIE("socket");
    }

    bzero((char *) &server_address, sizeof(server_address));
    server_address.sin_family = AF_INET;
    server_address.sin_addr.s_addr = INADDR_ANY;
    server_address.sin_port = htons(server_port);

	// connect the client socket to server socket
	if (connect(server_socket, (struct sockaddr*)&server_address, sizeof(server_address)) != 0) {
        DIE("TCP Server Unvailable\n");
	}

	fprintf( stdout, "connected to the server ... \n");

    return server_socket;
}



int main(int argc, char **argv) {


	int rc = 0 ;
	int id=12;
    int server_port;
	char *server_name = "127.0.0.1";
	char current_time_date[128] ;

	signal(SIGCHLD, SIG_IGN);

	
	/* Argument Parsing */
	parse_arguments(argc, argv, G_MQTT_topic_name , sizeof (G_MQTT_topic_name) , &server_port);


	/* TCP Server */
    fprintf(stdout, "Redirecting  MQTT Messages To %s:%d \n" , server_name , server_port );
	GF_forward_socket = open_listening_port(server_port);
	

	/* MQTT Server */
	mosquitto_lib_init();

	struct mosquitto *mosq;

	get_current_time(current_time_date , sizeof(current_time_date) ) ;
	fprintf(stdout,"Broker Name : %s\n",current_time_date);

	mosq = mosquitto_new(current_time_date, true, &id);
	
	mosquitto_connect_callback_set(mosq, on_connect);
	mosquitto_message_callback_set(mosq, on_message);

	rc = mosquitto_connect(mosq, "localhost", 1883, 10);
	if(rc) {
		fprintf( stdout ,"Could not connect to Broker with return code %d\n", rc);
		return -1;
	}

	mosquitto_loop_start(mosq);
	fprintf( stdout ,"Press Enter to quit...\n");
	getchar();
	mosquitto_loop_stop(mosq, true);

	mosquitto_disconnect(mosq);
	mosquitto_destroy(mosq);
	mosquitto_lib_cleanup();


	close(GF_forward_socket);

	return 0;
}
