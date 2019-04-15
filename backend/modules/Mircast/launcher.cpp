#include "launcher.h"

Launcher::Launcher(QObject *parent) :
    QObject(parent),
    m_message(""),
    m_port(12345),
    m_compression(9),
    m_process(new QProcess(this))
{
    connect(m_process,SIGNAL(started()), this,SLOT(updateActive()));
    connect(m_process,SIGNAL(stateChanged(QProcess::ProcessState)), this,SLOT(updateActive()) );
    connect(m_process,SIGNAL(readyReadStandardOutput()), this,SLOT(updateOutputMsg()) );
    connect(m_process,SIGNAL(readyReadStandardError()), this,SLOT(updateOutputMsg()) );
}

Launcher::~Launcher() {

}

void Launcher::updateOutputMsg() {
    if(m_process->state() == QProcess::Running) {
        QByteArray bytes = m_process->readAllStandardOutput();
        QString output = QString::fromLocal8Bit(bytes);
        m_message += output;
        Q_EMIT outputChanged();
    }
}

QString Launcher::getCommandOutput()
{
    if(m_process->state() == QProcess::Running) {
        QByteArray bytes = m_process->readAllStandardOutput();
        QString output = QString::fromLocal8Bit(bytes);
        m_message += output;
        Q_EMIT outputChanged();
        return m_message;
    }
    return QString("Not Running");
}

void Launcher::updateActive() {
    bool newActive = m_process->state() != QProcess::NotRunning;
    if(m_active != newActive) {
        m_active = newActive;
        this->getCommandOutput();
        Q_EMIT activeChanged();
    }
}

bool Launcher::isActive() {
    this->updateActive();
    return m_active;
}

bool Launcher::cast()
{
    QString command = QString("bash -mvlc \"mirscreencast -m /run/mir_socket --stdout --cap-interval 2 -s %1 %2 | %3 nc %4 %5 ;\"")
                        .arg(m_width)
                        .arg(m_height)
                        .arg(m_compression > 0 ? QString("gzip -%1 -c |").arg(m_compression) : "")
                        .arg(m_remoteIP)
                        .arg(m_port);

  return this->launch(command);
}

bool Launcher::host()
{
    QString command = QString("bash -mvlc \"nc -l %3 | gzip -dc | mplayer -demuxer rawvideo -rawvideo fps=12:w=%1:h=%2:format=rgba -\"")
                        .arg(m_width)
                        .arg(m_height)
                        .arg(m_port);

   return this->launch(command);
}

bool Launcher::launch(QString command)
{
     m_process->start(command);
     m_process->waitForStarted(10000);
     return  this->isActive();
}

bool Launcher::stop()
{
    m_process->terminate();
    m_process->kill();
    m_process->waitForFinished();
}
