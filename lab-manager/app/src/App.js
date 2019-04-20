import React, {Component} from 'react';
import logo from './logo.svg';
import './css/App.css';

class App extends Component {
    render() {
        return (
            <div className="App">
                <header className="App-header">
                    <img src={logo} className="App-logo" alt="logo"/>
                    <h1 className="App-title">Welcome to React</h1>
                </header>
                <p className="App-intro">
                    To get started, edit <code>src/App.js</code> and save to reload.
                </p>
                {/*<Masthead*/}
                {/*    iconImg="static/media/logo-alt.8041a7d6.svg"*/}
                {/*    titleImg="static/media/brand-alt.d6764776.svg"*/}
                {/*    title="Patternfly React"*/}
                {/*    onTitleClick={handleTitleClick}*/}
                {/*    onNavToggleClick={handleNavToggle}*/}
                {/*>*/}
                {/*  <MastheadCollapse>*/}
                {/*    <MastheadDropdown id="app-help-dropdown" noCaret title={<span />}>*/}
                {/*      <MenuItem eventKey="1">*/}
                {/*        Help*/}
                {/*      </MenuItem>*/}
                {/*      <MenuItem eventKey="2">*/}
                {/*        About*/}
                {/*      </MenuItem>*/}
                {/*    </MastheadDropdown>*/}
                {/*    <MastheadDropdown id="app-user-dropdown" title={[<Icon />,<span />]}>*/}
                {/*      <MenuItem eventKey="1">*/}
                {/*        User Preferences*/}
                {/*      </MenuItem>*/}
                {/*      <MenuItem eventKey="2">*/}
                {/*        Logout*/}
                {/*      </MenuItem>*/}
                {/*    </MastheadDropdown>*/}
                {/*  </MastheadCollapse>*/}
                {/*</Masthead>*/}
            </div>
        );
    }
}

export default App;
