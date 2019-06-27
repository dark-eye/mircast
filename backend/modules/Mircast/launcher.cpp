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
	Q_EMIT abilityChanged();
}

Launcher::~Launcher() {

}

void Launcher::updateOutputMsg() {
    if(m_process->state() == QProcess::Running) {
        QByteArray bytes = m_process->readAllStandardOutput();
        QString output = QString::fromLocal8Bit(bytes);
        m_message += output + "\n";
		bytes = m_process->readAllStandardError();
        QString errors = QString::fromLocal8Bit(bytes);
        m_message += errors + "\n";
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

bool Launcher::canHost() {
    QFileInfo mplayer("/usr/bin/mplayer");
	QFileInfo bash("/bin/bash");
	QFileInfo gzip("/bin/gzip");
	QFileInfo nc("/bin/nc");

	return bash.exists() && mplayer.exists() && gzip.exists() && nc.exists();
}

bool Launcher::canCast() {
    QFileInfo mirscreencast("/usr/bin/mirscreencast");
	QFileInfo bash("/bin/bash");
	QFileInfo gzip("/bin/gzip");
	QFileInfo nc("/bin/nc");

	return  bash.exists() && mirscreencast.exists() && gzip.exists() && nc.exists();
}


QString Launcher::getCastCommand()
{
	 return QString("bash -mvlc \"mirscreencast -m /run/mir_socket --stdout --cap-interval 3 -s %1 %2 | %3 nc %4 %5 ;\"")
                        .arg(m_width)
                        .arg(m_height)
                        .arg(m_compression > 0 ? QString("gzip -%1 -c |").arg(m_compression) : "")
                        .arg(m_remoteIP)
                        .arg(m_port);
}

bool Launcher::cast()
{
    QString command = this->getCastCommand();

  return this->launch(command);
}

QString Launcher::getHostCommand()
{
	 return QString("bash -mvlc \"nc -l %1 | %2 mplayer -demuxer rawvideo -rawvideo fps=15:w=%3:h=%4:format=rgba -\"")
						.arg(m_port)
						.arg(m_compression > 0 ? QString("gzip -dc |") : "")
						.arg(m_width)
						.arg(m_height);


}

bool Launcher::host()
{
    QString command = this->getHostCommand();

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
