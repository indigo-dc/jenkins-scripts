Name:           test-dep
Version:        1.0.0
Release:        1%{?dist}
Summary:        Testing dependency

License:        Public Domain
URL:            https://github.com/indigo-dc/jenkins-scripts

BuildArch:      noarch

%description
Testing dependency.


%prep


%build


%install
mkdir -p %{buildroot}%{_datadir}/%{name}
echo Test > %{buildroot}%{_datadir}/%{name}/test.txt


%check
# no checks


%files
%{_datadir}/%{name}/


%changelog
* Mon Jan 30 2017 František Dvořák <valtri@civ.zcu.cz> - 1.0.0-1
- Initial package
