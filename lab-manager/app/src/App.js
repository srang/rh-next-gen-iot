import React, {Component} from 'react';
import logo from './img/redhat_reverse.png';
import summit from './img/summit.svg';
import './css/App.css';
import { Button } from 'patternfly-react';
import { AboutModal } from 'patternfly-react';
// import logo from '~patternfly/dist/img/logo-alt.svg';

class LabAboutModal extends Component {
    constructor() {
        super();
        this.state = { showModal: false };
        this.open = this.open.bind(this);
        this.close = this.close.bind(this);
    }
    open() {
        this.setState({ showModal: true });
    }
    close() {
        this.setState({ showModal: false });
    }
    render() {
        return (
            <div>
                <Button bsStyle="primary" bsSize="large" onClick={this.open}>
                    Launch About Modal
                </Button>

                <AboutModal
                    show={this.state.showModal}
                    onHide={this.close}
                    productTitle="Next Gen Technologies at Scale"
                    logo={summit}
                    altLogo="Red Hat Summit 2019 Logo"
                    trademarkText="github.com/ablock/something"
                >
                    <AboutModal.Versions>
                        <AboutModal.VersionItem label="Presenter" versionText="Sam Rang" />
                        <AboutModal.VersionItem label="Presenter" versionText="Andrew Block" />
                        <AboutModal.VersionItem label="Presenter" versionText="Ishu Verma" />
                        <AboutModal.VersionItem label="Presenter" versionText="Hugo Guerrero Olivares" />
                        <AboutModal.VersionItem label="Presenter" versionText="Christina Lin" />
                    </AboutModal.Versions>
                </AboutModal>
            </div>
        );
    }
}

class App extends Component {
    render() {
        return (
            <div className="App">
                <header className="App-header">
                    <img src={logo} className="App-logo" alt="logo"/>
                    <h1 className="App-title">Welcome to React</h1>
                    <LabAboutModal />
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
