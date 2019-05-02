import {SockJS} from 'sockjs-client';
import {Stomp} from 'stompjs';

export function register(registrations) {
    const socket = SockJS('/sensordata');
    const stompClient = Stomp.over(socket);
    stompClient.connect({}, function(frame) {
        registrations.forEach(function (registration) {
            stompClient.subscribe(registration.route, registration.callback);
        });
    });
}

