import React, {Component} from 'react';
import {LabAboutMenuItem} from './LabAboutMenuItem.js'
import {VerticalNav, Icon, Dropdown, MenuItem} from 'patternfly-react';
import './css/App.css';
import pfLogo from './img/logo-alt.svg';

class App extends Component {
    render() {
        return (
            <div className="layout-pf layout-pf-fixed faux-layout">
                <VerticalNav sessionKey="storybookNoHoverDelay" hoverDelay={0}>
                    <VerticalNav.Masthead title="Next Gen Technologies at Scale" iconImg={pfLogo}/>
                    <VerticalNav.Item title="Pump Status" iconClass="fa fa-tachometer"/>
                    <VerticalNav.Item title="Lab Control" iconClass="fa fa-sliders"/>
                </VerticalNav>
                <div className="container-fluid container-cards-pf container-pf-na…">
                    <div className="row row-cards-pf">
                        <LabAboutMenuItem buttonTitle="About the Lab"/>
                    </div>
                </div>
            </div>
        );
    }
}

export default App;
