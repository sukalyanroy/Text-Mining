# -*- coding: utf-8 -*-
# <nbformat>3.0</nbformat>

# <headingcell level=2>

# Latent Semantic Analysis

# <markdowncell>

# * Latent Semantic Analysis (LSA) is a framework for analyzing text using matrices
# * Find relationships between documents and terms within documents
# * Used for document classification, clustering, text search, and more
# * Lots of experts here at CU Boulder!

# <headingcell level=2>

# sci-kit learn

# <markdowncell>

# * sci-kit learn is a Python library for doing machine learning, feature selection, etc.
# * Integrates with numpy and scipy
# * Great documentation and tutorials

# <headingcell level=2>

# Vectorizing text

# <markdowncell>

# * Most machine-learning and statistical algorithms only work with structured, tabular data
# * A simple way to add structure to text is to use a document-term matrix

# <headingcell level=2>

# Document-term matrix

# <codecell>

import sklearn
# Import all of the scikit learn stuff
from __future__ import print_function
from sklearn.decomposition import TruncatedSVD
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.preprocessing import Normalizer
from sklearn import metrics
from sklearn.cluster import KMeans, MiniBatchKMeans

import pandas as pd
import warnings
# Suppress warnings from pandas library
warnings.filterwarnings("ignore", category=DeprecationWarning,
                        module="pandas", lineno=570)

import numpy

# <codecell>

example = ["Machine learning is super fun",
           "Python is super, super cool",
           "Statistics is cool, too",
           "Data science is fun",
           "Python is great for machine learning",
           "I like football",
           "Football is great to watch"]
vectorizer = CountVectorizer(min_df = 1, stop_words = 'english')
dtm = vectorizer.fit_transform(example)
pd.DataFrame(dtm.toarray(),index=example,columns=vectorizer.get_feature_names()).head(10)

# <markdowncell>

# * Each row represents a document. Each column represents a word. So each document is a 13-dim vector.
# * Each entry equals the number of times the word appears in the document
# * Note: order and proximity of words in documents is NOT accounted for. Called a "bag of words" representation.

# <codecell>

# Get words that correspond to each column
vectorizer.get_feature_names()

# <markdowncell>

# * Example: "machine" appears once in the first document, "super" appears twice in the second document, and "statistics" appears zero times in the third document.

# <headingcell level=2>

# Singular value decomposition and LSA

# <codecell>

# Fit LSA. Use algorithm = “randomized” for large datasets
lsa = TruncatedSVD(2, algorithm = 'arpack')
dtm_lsa = lsa.fit_transform(dtm)
dtm_lsa = Normalizer(copy=False).fit_transform(dtm_lsa)

# <markdowncell>

# * Each LSA component is a linear combination of words 

# <codecell>

pd.DataFrame(lsa.components_,index = ["component_1","component_2"],columns = vectorizer.get_feature_names())

# <markdowncell>

# * Each document is a linear combination of the LSA components

# <codecell>

pd.DataFrame(dtm_lsa, index = example, columns = ["component_1","component_2"])

# <codecell>

xs = [w[0] for w in dtm_lsa]
ys = [w[1] for w in dtm_lsa]
xs, ys

# <codecell>

# Plot scatter plot of points
%pylab inline
import matplotlib.pyplot as plt
figure()
plt.scatter(xs,ys)
xlabel('First principal component')
ylabel('Second principal component')
title('Plot of points against LSA principal components')
show()

# <headingcell level=2>

# Geometric picture

# <codecell>

# Plot scatter plot of points with vectors
%pylab inline
import matplotlib.pyplot as plt
plt.figure()
ax = plt.gca()
ax.quiver(0,0,xs,ys,angles='xy',scale_units='xy',scale=1, linewidth = .01)
ax.set_xlim([-1,1])
ax.set_ylim([-1,1])
xlabel('First principal component')
ylabel('Second principal component')
title('Plot of points against LSA principal components')
plt.draw()
plt.show()

# <markdowncell>

# * We have reduced dimension from 13-dim to 2-dim (and have lost some info)
# * Similar docs point in similar directions. Dissimilar docs have perpendicular (orthogonal) vectors. "Cosine similarity"
# * Can use cosine similarity for search: which doc has the smallest angle with search term?

# <headingcell level=2>

# Document similarity using LSA

# <codecell>

# Compute document similarity using LSA components
similarity = np.asarray(numpy.asmatrix(dtm_lsa) * numpy.asmatrix(dtm_lsa).T)
pd.DataFrame(similarity,index=example, columns=example).head(10)

# <headingcell level=2>

# Improvements and next steps:

# <markdowncell>

# * Vectorize with TFIDF (term-frequency inverse document-frequency: uses overall frequency of words to weight document-term matrix)
# * Use LSA components as features in machine learning algorithm: clustering, classification, regression
# * Alternative dimensionality reduction: Isomap, Random Matrix Methods, Laplacian Eigenmaps, Kernel PCA (cool names!)

# <headingcell level=2>

# Try it on your own

# <markdowncell>

# * List of 140k StackOverflow posts taken from a Kaggle competition
# * Sample code on my personal website (www.williamgstanton.com): LSA (with 3 components instead of 2), document similarity, clustering

# <codecell>

# Import pandas for data frame functionality, CSV import, etc.
import pandas as pd

# <codecell>

# Import data as csv. Change directory to file location on your computer.
dat = pd.read_csv("/Users/wstanton/Desktop/stack_overflow/train-sample.csv")

# <codecell>

# Extract titles column from DataFrame
titles  = dat.Title.values

# <codecell>

# Extract bodies column from DataFrame
bodies = dat.BodyMarkdown.values

# <headingcell level=2>

# Thanks for listening!

# <markdowncell>

# * Thanks to Data Science Assoc. and Meetup for inviting me to talk
# * Find me on LinkedIn: www.linkedin.com/in/willstanton
# * Personal website: www.williamgstanton.com
# * Any further questions?
