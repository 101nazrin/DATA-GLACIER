from flask import Flask, request, jsonify,render_template,json,url_for
import numpy as np
import pickle
import pandas as pd

app = Flask(__name__)  


@app.route('/')
def home():
    return render_template('index.html')
                               #Creating the Flask App

@app.route('/WineQualityPrediction', methods=['POST'])                   
def wine_quality():
    # loading the Logistic regression model
    model = pickle.load(open('wine_qualityprediction.pickle','rb'))  
    #Getting the values from html page        
    features = [float(x) for x in request.form.values()]
    feature_array = [np.array(features)]
    #converting to an array to make to compatible for model prediction
    quality_prediction = model.predict(feature_array)
    #rounding the array Value
    quality = round(quality_prediction[0])
    #Retuning the predicted value tpo html page
    return render_template('index.html', Quality='Quality of Wine is  {}'.format(quality))
   
    
if __name__ == '__main__':                                   #Ensuring the app is running 
    app.run(debug=True)

 


