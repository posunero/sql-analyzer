from __future__ import annotations
from typing import Any, Dict, List, Tuple, Optional
from ...analysis.models import AnalysisResult
from jinja2 import Environment, FileSystemLoader, select_autoescape, PackageLoader
import datetime
import os

def format_html(result: AnalysisResult, **kwargs: Any) -> str:
    """
    Formats the analysis result as a single, self-contained HTML file for developer readability.
    """
    # Determine the path to the templates directory
    template_dir: str = os.path.join(os.path.dirname(__file__), 'templates')
    env = Environment(
        loader=FileSystemLoader(template_dir),
        autoescape=select_autoescape(['html', 'xml'])
    )
    template = env.get_template('report_template.html.j2')
    object_interactions_sorted: List[Tuple[Tuple[str, str], List[str]]] = [
        (obj_key, sorted(list(actions)))
        for obj_key, actions in sorted(result.object_interactions.items())
    ]
    context: Dict[str, Any] = {
        'result': result,
        'generation_time': datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S UTC"),
        'object_interactions_sorted': object_interactions_sorted,
    }
    html_output: str = template.render(context)
    return html_output

def format_validation_results(validation_results: Dict[str, Tuple[bool, Optional[str]]]) -> str:
    """Format validation results as HTML."""
    # Use package loader to find templates in reporting/templates
    env = Environment(
        loader=PackageLoader('sql_analyzer.reporting', 'templates'),
        autoescape=select_autoescape(['html', 'xml'])
    )
    template = env.get_template('validation_report.html')
    context: Dict[str, Any] = {
        'total_files': len(validation_results),
        'valid_files': sum(1 for valid, _ in validation_results.values() if valid),
        'invalid_files': sum(1 for valid, _ in validation_results.values() if not valid),
        'results': validation_results
    }
    html_output: str = template.render(context)
    return html_output 