from ...analysis.models import AnalysisResult
from jinja2 import Environment, FileSystemLoader, select_autoescape
import datetime
import os

def format_html(result: AnalysisResult, **kwargs) -> str:
    """
    Formats the analysis result as a single, self-contained HTML file for developer readability.
    """
    # Determine the path to the templates directory
    template_dir = os.path.join(os.path.dirname(__file__), 'templates')
    env = Environment(
        loader=FileSystemLoader(template_dir),
        autoescape=select_autoescape(['html', 'xml'])
    )
    template = env.get_template('report_template.html.j2')
    object_interactions_sorted = sorted(result.object_interactions.items())
    context = {
        'result': result,
        'generation_time': datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S UTC"),
        'object_interactions_sorted': [
            (obj_key, sorted(list(actions))) for obj_key, actions in object_interactions_sorted
        ],
    }
    html_output = template.render(context)
    return html_output 