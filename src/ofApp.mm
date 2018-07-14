#include "ofApp.h"

//--------------------------------------------------------------
ofApp :: ofApp (ARSession * session){
    this->session = session;
    cout << std::string("creating ofApp") << endl;
}

ofApp::ofApp(){}

//--------------------------------------------------------------
ofApp :: ~ofApp () {
    cout << std::string("destroying ofApp") << endl;
}

//--------------------------------------------------------------
void ofApp::setup() {
    ofBackground(127);

    img.load("OpenFrameworks.png");

    int fontSize = 8;
    if (ofxiOSGetOFWindow()->isRetinaSupportedOnDevice())
        fontSize *= 2;

    font.load("fonts/mono0755.ttf", fontSize);

    processor = ARProcessor::create(session);
    processor->setup();

    ikedaNumberShader.load("shaders/ikeda_numbers");
    gradientShader.load("shaders/hello-world");

    activeShader = gradientShader;

    // Trying out 3D stuff
    ofEnableLighting();
    ofEnableDepthTest();
    light.setup();
    light.enable();
    light.setPosition(-10,10,0);

    material.setDiffuseColor(beeBlue);
    material.setAmbientColor(beeBlue);
    material.setSpecularColor(ofColor::white);
}



//--------------------------------------------------------------
void ofApp::update(){

    processor->update();

}

//--------------------------------------------------------------
void ofApp::draw() {
    ofEnableAlphaBlending();

    ofDisableDepthTest();
    processor->draw();
    ofEnableDepthTest();


    if (session.currentFrame){
        if (session.currentFrame.camera){

            camera.begin();
            processor->setARCameraMatrices();

            for (int i = 0; i < session.currentFrame.anchors.count; i++){
                ARAnchor * anchor = session.currentFrame.anchors[i];

                // note - if you need to differentiate between different types of anchors, there is a 
                // "isKindOfClass" method in objective-c that could be used. For example, if you wanted to 
                // check for a Plane anchor, you could put this in an if statement.
                // if([anchor isKindOfClass:[ARPlaneAnchor class]]) { // do something if we find a plane anchor}
                // Not important for this example but something good to remember.

                ofPushMatrix();
                ofMatrix4x4 mat = ARCommon::convert<matrix_float4x4, ofMatrix4x4>(anchor.transform);
                ofMultMatrix(mat);

                ofSetColor(255);
                ofRotateZDeg(90);

                if (bUseShader) {
                    activeShader.begin();
                    activeShader.setUniform1f("u_time", ofGetElapsedTimef());
                    activeShader.setUniform2f("u_resolution", ofGetWidth(), ofGetHeight());
                } else {
                    material.begin();
                }

                ofDrawSphere(0, 0, radius, radius);

                if (bUseShader) {
                    activeShader.end();
                } else {
                    material.end();
                }

                light.setPosition(0,0,0);
                ofPopMatrix();
            }
            camera.end();
        }

    }
    ofDisableDepthTest();
    // ========== DEBUG STUFF ============= //
    processor->debugInfo.drawDebugInformation(font);


}

//--------------------------------------------------------------
void ofApp::exit() {
    //
}

//--------------------------------------------------------------
void ofApp::touchDown(ofTouchEventArgs &touch){
    if (session.currentFrame){
        ARFrame *currentFrame = [session currentFrame];

        matrix_float4x4 translation = matrix_identity_float4x4;
        translation.columns[3].z = -0.2;
        matrix_float4x4 transform = matrix_multiply(currentFrame.camera.transform, translation);

        // Add a new anchor to the session
        ARAnchor *anchor = [[ARAnchor alloc] initWithTransform:transform];

        [session addAnchor:anchor];
    }
}

//--------------------------------------------------------------
void ofApp::touchMoved(ofTouchEventArgs &touch){

}

//--------------------------------------------------------------
void ofApp::touchUp(ofTouchEventArgs &touch){

}

//--------------------------------------------------------------
void ofApp::touchDoubleTap(ofTouchEventArgs &touch){
    bUseShader = !bUseShader;
}

//--------------------------------------------------------------
void ofApp::lostFocus(){

}

//--------------------------------------------------------------
void ofApp::gotFocus(){

}

//--------------------------------------------------------------
void ofApp::gotMemoryWarning(){

}

//--------------------------------------------------------------
void ofApp::deviceOrientationChanged(int newOrientation){
    processor->updateDeviceInterfaceOrientation();
    processor->deviceOrientationChanged();

}


//--------------------------------------------------------------
void ofApp::touchCancelled(ofTouchEventArgs& args){

}
