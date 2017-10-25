import numpy as np
from sklearn.linear_model import LinearRegression

xx = np.linspace(-3, 3, 300)
yy = np.array([np.sin(x) + np.random.randn() * .5 for x in xx])

lm = LinearRegression().fit(xx.reshape(-1, 1), yy)

import coremltools

coreml_model = coremltools.converters.sklearn.convert(lm, ["value"])
coreml_model.author = "Markus Muehlberger"
coreml_model.input_description["value"] = "Input Value"
coreml_model.output_description["prediction"] = "Output Prediction"

coreml_model.save("LinearRegression.mlmodel")
