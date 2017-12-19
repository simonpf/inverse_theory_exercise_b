from IPython.core.display import HTML, display

################################################################################
# Make notebooks look a bit better ...
################################################################################

display(HTML("""
<style>
div.output_area img, div.output_area svg {
    display: block;
    margin-left: auto;
    margin-right: auto;
    max-width: 100%;
    height: auto;
}

.rendered_html h1 {
    font-size: 185.7%;
    margin: 1.08em 0 0 0;
    margin-top: 1.08em;
    margin-bottom: 1.08em;
    font-weight: bold;
    line-height: 1.0;
    text-align: center;
}

div.output_area img, div.output_area svg {
    display: block;
    margin-left: auto;
    margin-right: auto;
    max-width: 100%;
    height: auto;
}

div.cell {
    margin-bottom: 30px;
}

#notebook-container {
    padding: 60px;
    background-color: #fff;
    min-height: 0;
    -webkit-box-shadow: 0px 0px 12px 1px rgba(87, 87, 87, 0.2);
    box-shadow: 0px 0px 12px 1px rgba(87, 87, 87, 0.2);
}
</style>
     """))

################################################################################
# Matplotlib Setup
################################################################################

import matplotlib.pyplot as plt
plt.style.use('ggplot')
