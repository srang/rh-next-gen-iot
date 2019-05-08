import React, {Component} from 'react';
import {VerticalNav} from 'patternfly-react';
import './css/App.css';
import pfLogo from './img/logo-alt.svg';
import {PumpListView} from "./PumpListView";
import {PumpControlView} from "./PumpControlView";

class App extends Component {

    constructor() {
        super();
        this.onClick = this.onClick.bind(this)
        this.state = {
            content: <PumpListView/>
        }
    }

    onClick(event) {
        // if (event.href === "#pumplist") {
            this.setState({content: <PumpListView/>});
        // } else {
        //     this.setState({content: <PumpControlView/>})
        // }
    }

    render() {
        return (
            <div className="layout-pf layout-pf-fixed faux-layout">
                <VerticalNav sessionKey="storybookNoHoverDelay" hoverDelay={0}>
                    <VerticalNav.Masthead title="Next Gen Technologies at Scale" iconImg={pfLogo}/>
                    <VerticalNav.Item href="#pumplist" title="Pump Status" iconClass="fa fa-tachometer"
                                      onClick={this.onClick}/>
                    {/*<VerticalNav.Item href="#pumpcontrol" title="Lab Control" iconClass="fa fa-sliders"*/}
                    {/*                  onClick={this.onClick}/>*/}
                </VerticalNav>
                <div className="container-fluid container-pf-nav-pf-vertical nav-pf-persistent-secondary"
                     style={{marginBottom: '20px', marginTop: '40px'}}>
                    {this.state.content}
                </div>
            </div>
        );
    }
}

export default App;
