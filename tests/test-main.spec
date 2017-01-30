Name:           test-main
Version:        1.0.0
Release:        1%{?dist}
Summary:        Testing package

License:        Public Domain
URL:            https://github.com/indigo-dc/jenkins-scripts

BuildArch:      noarch
BuildRequires:  test-dep

%description
Testing package.


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
